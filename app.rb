require 'pry'
require 'sinatra'
require 'better_errors'
require 'sinatra/reloader'
require 'pg'

require './models/squad'
require './models/student'

set :conn, PG.connect( dbname: 'weekendlab' ) 

#PG.connect 
#set 

before do
  @conn = settings.conn
  Squad.conn = @conn
  Student.conn = @conn
end

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# SQUAD ROUTES

get '/' do
  redirect '/squads'
end

get '/squads' do
  @squads = Squad.all
  erb :'squads/index'
end

get '/squads/new' do
  erb :'squads/add'
end

get '/squads/:id' do
  @squad = Squad.find params[:id].to_i 

  erb :'squads/show'
end

get '/squads/:id/edit' do
  @squad = Squad.find(params[:id].to_i)
  erb :'squads/edit'
end

post '/squads' do
  Squad.create params
  redirect '/squads'
end

put '/squads/:id' do
  s = Squad.find(params[:id].to_i)
  s.name = params[:name]
  s.mascot = params[:mascot]
  s.save
  redirect '/squads'
end

delete '/squads/:id' do
  Squad.find(params[:id].to_i).destroy
  redirect '/squads'
end

# STUDENT ROUTES
#find and list students who share the same squad id and render to student index page
get '/squads/:squad_id/students' do
  @students = Squad.find(params[:squad_id].to_i).students
  erb :'students/index'
end

#Creating a new Burt McGuert and NOT RENDERING THE MAN
get '/squads/:squad_id/students/new' do
  @squad_id = params[:squad_id].to_i
  erb :'students/add'  
end

#Show current students in the squad 
get '/squads/:squad_id/students/:student_id' do

  @student = Student.find(params[:student_id].to_i)
  erb :'students/show'

end

# get '/squads/:squad_id/students/:student_id/edit' do
#   squad_id = params[:squad_id].to_i
#   id = params[:student_id].to_i
#   student = @conn.exec('SELECT * FROM students WHERE id = $1 AND squad_id = $2', [ id, squad_id ] )
#   @student = student[0]
#   erb :'students/edit'
# end

# Show the page where Burt McGuert can be added to
post '/squads/:squad_id/students' do
  Student.create params
  redirect "/squads/#{params[:squad_id].to_i}"
end

# put '/squads/:squad_id/students/:student_id' do
#   id = params[:student_id].to_i
#   @conn.exec('UPDATE students SET name=$1, age=$2, spirit_animal=$3 WHERE id = $4', [ params[:name], params[:age], params[:spirit], id ] )
#   redirect "/squads/#{params[:squad_id].to_i}"
# end

delete '/squads/:squad_id/students/:student_id' do
  Student.find(params[:student_id].to_i).destroy 
  redirect "/squads/#{params[:squad_id].to_i}"
end
