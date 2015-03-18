class BoardsController < ApplicationController
  def index
  end

  def new
    @boards = Board.new
  end

  def create
    @board = Board.new(params_board)
    @board.save
    redirect_to "/boards"
  end

  def params_board
    params.permit(:title, :editor)
  end
end
