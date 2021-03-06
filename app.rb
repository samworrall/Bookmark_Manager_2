require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/bookmark'

class BookmarkManager < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    @bookmarks = Bookmark.all
    erb(:index)
  end

  get '/add' do
    erb(:add)
  end

  post '/add' do
    if params[:bookmark] =~ /\A#{URI::regexp(['http', 'https'])}\z/
      Bookmark.add(params[:bookmark], params[:title])
      redirect('/')
    else
      flash[:error] = "Invalid url"
      redirect('/add')
    end
  end

  get '/delete' do
    erb(:delete)
  end

  post '/delete' do
    if Bookmark.all.any? { |h| h[:title] == params[:title] }
      Bookmark.delete(params[:title])
      redirect('/')
    else
      flash[:error_delete] = "Invalid title"
      redirect('/delete')
    end
  end

  get '/update' do
    erb(:update)
  end

  post '/update' do
    if Bookmark.all.any? { |h| h[:title] == params[:original_title] }
      Bookmark.update(params[:original_title], params[:new_title])
      redirect('/')
    else
      flash[:error_update] = "Invalid title"
      redirect('/update')
    end
  end

  run! if app_file == $0

end
