class Api::TodoListsController < Api::ApiController
	
	def index
		Rails.logger.info "Current user: #{current_user.inspect}"
    render json: TodoList.all
  end

  def show
  	list = current_user.todo_lists.find(params[:id])
  	render json: list.as_json(include:[:todo_items])
  end

  def create
  	list = current_user.todo_lists.new(list_params)
  	if list.save
  		render status: 200, json: {
  			messgae: "Succesfully created a to-do list",
  			todo_list: list
  		}.to_json
  	else
  		render status: 500, json: {
  			errors: list.errors
  		}.to_json
  	end
  end

  def destroy
  	list = current_user.todo_lists.find(params[:id])
  	list.destroy
  	render status: 200, json: {
  		messgae: "Succesfully deleted to-do list"
  	}.to_json
  end

  def update
  	list = current_user.todo_lists.find(params[:id])
  	if list.update(list_params)
  		render status: 200, json: {
  			messgae: "Succesfully updated",
  			todo_list: list
  		}.to_json
  	else
  		render status: 422, json: {
  			messgae: "Updated was not Succesful",
  			todo_list: list
  		}.to_json
  	end
  end

  private
  
  def list_params
  	params.require('todo_list').permit('title')
  end
end