from django.urls import path
from . import views
from .views import ProfileView, SignupAPI, SuggestedFriendsView
from .views import register_user, create_fitness_details, create_fitness_group
from django.urls import path
from .views import LoginView

urlpatterns = [
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/fitness-groups/', views.FitnessGroupList.as_view(), name='fitness_group_api'),
    path('api/fitness-details/', views.FitnessDetailsList.as_view(), name='fitness_details_api'),
    path('login/', LoginView.as_view(), name='login'),
    path('api/signup/', SignupAPI.as_view(), name='signup_api'),
    path('api/profile/', ProfileView.as_view(), name='profile_api'),
    path('api/suggested-friends/', SuggestedFriendsView.as_view(), name='suggested-friends'),
    path('signup/', views.signup_view, name='signup'),
    path('onboard/buddy/', views.onboard_buddy_view, name='onboard_buddy'),
    path('onboard/organizer/', views.onboard_organizer_view, name='onboard_organizer'),
    path('register/', register_user, name='register'),
    path('fitness-details/', create_fitness_details, name='fitness_details'),
    path('fitness-group/', create_fitness_group, name='fitness_group'),
    path('api/users/', views.get_all_users, name='get_all_users'),
]

