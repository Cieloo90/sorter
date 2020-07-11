require 'pry'
require 'sinatra'

require_relative './models'

get '/' do
  erb :index
end

post '/add_score' do 
  Item[params[:selected_item]].add_score
  Item[params[:first_item]].add_compares_amount
  Item[params[:second_item]].add_compares_amount
  if params[:selected_item] == params[:first_item]
    Compare.insert(first_item_id: params[:first_item], second_item_id: params[:second_item], score: 1)
    Compare.insert(first_item_id: params[:second_item], second_item_id: params[:first_item], score: 0)
  else
    Compare.insert(first_item_id: params[:second_item], second_item_id: params[:first_item], score: 1)
    Compare.insert(first_item_id: params[:first_item], second_item_id: params[:second_item], score: 0) 
  end
  redirect '/'
end

post '/add_item' do
  Item.insert(name: params[:name]) if params[:name] != ''
  redirect '/'
end
