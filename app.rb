require 'pry'
require 'sinatra'
require 'better_errors'
require 'sinatra/reloader'
require 'pg'

set :conn, PG.connect( dbname: 'weekendlab' )

before do
  @conn = settings.conn
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
  squads = []
  @conn.exec("SELECT * FROM squads") do |result|
    result.each do |row|
        squads << row
    end
  end
  @squads = squads
  erb :'squads/index'
end

get '/squads/new' do
  erb :'squads/add'
end

get '/squads/:id' do
  id = params[:id].to_i
  squad = @conn.exec('SELECT * FROM squads WHERE id = ($1)', [ id ] )
  @squad = squad[0]
  students = []
  @conn.exec("SELECT * FROM students WHERE squad_id = ($1)", [@squad["id"]]) do |result|
    result.each do |row|
        students << row
    end
  end
  @students = students
  erb :'squads/show'
end

get '/squads/:id/edit' do
  id = params[:id].to_i
  squad = @conn.exec('SELECT * FROM squads WHERE id = ($1)', [ id ] )
  @squad = squad[0]
  erb :'squads/edit'
end

post '/squads' do
  @conn.exec('INSERT INTO squads (name, mascot) values ($1, $2)', [ params[:name], params[:mascot] ] )
  redirect '/squads'
end

put '/squads/:id' do
  id = params[:id].to_i
  @conn.exec('UPDATE squads SET name=$1, mascot=$2 WHERE id = $3', [ params[:name], params[:mascot], id ] )
  redirect '/squads'
end

delete '/squads/:id' do
  id = params[:id].to_i
  @conn.exec('DELETE FROM squads WHERE id = $1', [ id ] )
  @conn.exec('DELETE FROM students WHERE squad_id = $1', [ id ] )
  redirect '/squads'
end

# STUDENT ROUTES

get '/squads/:squad_id/students' do
  students = []
  id = params[:squad_id].to_i
  @conn.exec("SELECT * FROM students WHERE squad_id = ($1)", [id]) do |result|
    result.each do |row|
        students << row
    end
  end
  @students = students
  erb :'students/index'
end

get '/squads/:squad_id/students/new' do
  @squad_id = params[:squad_id].to_i
  erb :'students/add'
end

get '/squads/:squad_id/students/:student_id' do
  squad_id = params[:squad_id].to_i
  id = params[:student_id].to_i
  student = @conn.exec('SELECT * FROM students WHERE id = $1 AND squad_id = $2', [ id, squad_id ] )
  @student = student[0]
  erb :'students/show'
end

get '/squads/:squad_id/students/:student_id/edit' do
  squad_id = params[:squad_id].to_i
  id = params[:student_id].to_i
  student = @conn.exec('SELECT * FROM students WHERE id = $1 AND squad_id = $2', [ id, squad_id ] )
  @student = student[0]
  erb :'students/edit'
end

post '/squads/:squad_id/students' do
  @conn.exec('INSERT INTO students (name, age, spirit_animal, squad_id) values ($1,$2,$3,$4)', [ params[:name]  ,params[:age],params[:spirit], params[:squad_id]])
  redirect "/squads/#{params[:squad_id].to_i}"
end

put '/squads/:squad_id/students/:student_id' do
  id = params[:student_id].to_i
  @conn.exec('UPDATE students SET name=$1, age=$2, spirit_animal=$3 WHERE id = $4', [ params[:name], params[:age], params[:spirit], id ] )
  redirect "/squads/#{params[:squad_id].to_i}"
end

delete '/squads/:squad_id/students/:student_id' do
  id = params[:student_id].to_i
  @conn.exec('DELETE FROM students WHERE id = ($1)', [ id ] )
  redirect "/squads/#{params[:squad_id].to_i}"
end
