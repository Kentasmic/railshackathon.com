class VotesController < ApplicationController
  before_action :authenticate_user!, only: %i[ create destroy ]
  before_action :set_entry, only: %i[ create ]

  def index
    @votes = current_user.votes.order(:position)
  end

  def create
    vote = current_user.votes.build(entry: @entry)
    if vote.save
      redirect_to @entry, notice: "Thank you for your vote."
    else
      redirect_to @entry, alert: vote.errors[:base].first
    end
  end

  def destroy
    vote = current_user.votes.find(params[:id])
    vote.destroy
    redirect_back fallback_location: entry_path(vote.entry), notice: "Your vote has been removed successfully."
  end

  def set_entry
    @entry = Entry.find(params[:entry])
  rescue ActiveRecord::RecordNotFound
    redirect_to entries_url
  end
end
