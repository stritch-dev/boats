require './config/environment'

use Rack::MethodOverride
use UserController
use BoatController
use ReservationController
run ApplicationController
