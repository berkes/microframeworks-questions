require "rubygems"
require "sinatra"
require "rack-flash"
require "data_mapper"
require "dm-sqlite-adapter"

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/questions.db")

class Question
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :question, Text
    property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the question table
Question.auto_upgrade!

# set flash messages.
enable :sessions
use Rack::Flash

before do
  content_type :html, 'charset' => 'utf-8'
end

# get the latest 20 Questions
get '/' do
  @questions = Question.all(:order => [ :id.desc ], :limit => 20)
  @message = flash
  erb :index
end

#Make a new question
post '/question' do
  # Quick roundtrip for basic requirement checking on the form.
  %w{name question}.each do |field|
    flash[:error] = "#{field.capitalize} is required" if params[field].nil? or params[field] == ""
    flash[:error] = "Max 160 characters allowed!" if params[field].size > 160 
  end

  # find out if the max characters for question is not surpassed.

  # Requirements met? then try to save the post.
  if flash[:error].nil?
    Question.new(:name => params[:name], :question => params[:question], :created_at => Time.now).save!
    flash[:notice] = "Question saved. Thanks <em>#{ h params[:name] }</em>"
  end

  redirect "/"
end
