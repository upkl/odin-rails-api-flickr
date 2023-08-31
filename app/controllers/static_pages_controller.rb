require 'flickr'

class StaticPagesController < ApplicationController
  def home
    return unless params[:username]

    begin
      flickr = Flickr.new(ENV.fetch('FLICKR_API_KEY', nil), ENV.fetch('FLICKR_API_SECRET', nil))
      flickr.test.echo
    rescue Flickr::FailedResponse
      redirect_to '/', alert: 'Failed to connect.' and return
    end

    begin
      @user = flickr.people.findByUsername(username: params[:username])
    rescue Flickr::FailedResponse
      redirect_to '/', alert: 'User not found.' and return
    end

    p @user, @user.nsid

    redirect_to '/', alert: 'User not found.' and return unless @user

    begin
      @photos = flickr.people.getPublicPhotos(user_id: @user.nsid)
      p @photos
    rescue Flickr::FailedResponse
      redirect_to '/', alert: 'Could not retrieve photos.'
    end
  end
end
