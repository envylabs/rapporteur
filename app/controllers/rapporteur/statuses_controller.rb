module Rapporteur
  class StatusesController < ApplicationController
    def show
      respond_to do |format|
        format.json do
          resource = Rapporteur.run

          if resource.errors.empty?
            render({:json => resource})
          else
            display_errors(resource, :json)
          end
        end
      end
    end


    private


    def display_errors(resource, format)
      render({format => {:errors => resource.errors}, :status => :internal_server_error})
    end
  end
end
