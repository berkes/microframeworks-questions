require "rubygems"
require "sinatra"
require "data_mapper"
require "dm-sqlite-adapter"
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
