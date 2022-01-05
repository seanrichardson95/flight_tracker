require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"
require "pg"
require "pry"
require "date"

require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, "secret"
  set :erb, escape_html: true
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "database_persistence.rb"
end

TIMEZONES = %w(HST AKDT AKST PDT PST MDT MST CDT CST EDT EST AST)

helpers do
  def get_date(date_time)
    return nil if date_time.nil?
    date_time[0,10]
  end

  def get_time(date_time)
    return nil if date_time.nil?
    date_time[11,5]
  end
end

def invalid_inputs?(params)
  if params.any? {|k,v| v.nil? || v == ""}
    "Please do not leave any field blank."
  elsif invalid_flight_number?(params["flight_number"])
    "Please input a 4-digit number in the 'Flight Number' field."
  elsif invalid_destination_code?(params["destination"])
    "Please input an all caps 3-letter code representing the destination\ninto the 'Destination' field."
  elsif invalid_date?(params["date"])
    "Please input a valid date in the yyyy-mm-dd format."
  elsif old_date?(params["date"])
    "Please input a day that is not in the past."
  elsif invalid_time?(params["time"])
    "Please input a valid time in the 24-hour hh:mm format."
  elsif invalid_timezone?(params["departure_time_zone"])
    "Please input one of the following U.S. time zones:\n#{TIMEZONES.join(', ')}"
  end
end

def invalid_flight_number?(number)
  !number.match?(/^[0-9]{4}$/)
end

def invalid_destination_code?(code)
  !code.match?(/^[A-Z]{3}$/)
end

def invalid_date?(date)
  # checks correct format
  return true unless date.match?(/^202[1-9]-(0[1-9]|1[0-2])-(0[1-9]|1[0-9]|2[0-9]|3[0-1])$/)
  # checks valid date
  begin
    date_arr = date.split("-").map {|s| s.to_i }
    Date.new(date_arr[0], date_arr[1], date_arr[2])
  rescue Date::Error
    return true
  else
    return false
  end
end

def old_date?(date)
  date_arr = date.split("-").map {|s| s.to_i}
  Date.today >= Date.new(date_arr[0], date_arr[1], date_arr[2])
end

def invalid_time?(time)
  !time.match?(/^([01][0-9]|2[0-3]):[0-5][0-9]$/)
end

def invalid_timezone?(timezone)
  !TIMEZONES.include?(timezone)
end

def format_flight_info(params)
 params["departure_time"] = params["date"] + " " + params["time"] + ":00"
 params
end

before do
  @flights = DatabasePersistence.new
end

get "/" do
  redirect "/flights"
end

# home page - view flights
get "/flights" do
  @flight_list = @flights.list
  erb :flights, layout: :layout
end

# view new flight page
get "/flights/new" do
  @post_action = "/flights"
  @flight = {}
  erb :add_flight, layout: :layout
end

# insert new flight
post "/flights" do
  session[:error] = invalid_inputs?(params)
  unless session[:error]
    @flights.add_flight(params)
    session[:success] = "The flight has been added."
    redirect "/flights"
  else
    @flight = format_flight_info(params)
    erb :add_flight, layout: :layout
  end
end

# view update flight page
get "/flights/:id/update" do
  @flight = @flights.flight_info(params[:id])
  @post_action = "/flights/#{params[:id]}"
  erb :add_flight, layout: :layout
end

# update flight
post "/flights/:id" do
  session[:error] = invalid_inputs?(params)
  unless session[:error]
    @flights.update_flight(params)
    session[:success] = "Flight #{params["id"]} has been updated."
    redirect "/flights"
  else
    @post_action = "/flights/#{params[:id]}"
    @flight = format_flight_info(params)
    erb :add_flight, layout: :layout
  end
end

# delete flight
post "/flights/:id/delete" do
  @flights.delete_flight(params[:id])
  redirect "/flights"
end
