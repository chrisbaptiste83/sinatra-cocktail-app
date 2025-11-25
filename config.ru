require './config/environment'

use Rack::MethodOverride

use SessionsController
use UsersController
use CommentsController
use CocktailRecipesController
run ApplicationController