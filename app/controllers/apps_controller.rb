# frozen_string_literal: true

class AppsController < ApplicationController
  def index
    @apps = App.all
  end
end
