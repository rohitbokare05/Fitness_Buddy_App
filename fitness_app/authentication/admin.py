from django.contrib import admin
from .models import CustomUser, FitnessDetails, FitnessGroup
from django.contrib.sessions.models import Session

admin.site.register(Session)

@admin.register(CustomUser)
class CustomUserAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'role', 'profile_picture')

@admin.register(FitnessDetails)
class FitnessDetailsAdmin(admin.ModelAdmin):
    list_display = ('user', 'fitness_goals', 'workout_preferences', 'availability')

@admin.register(FitnessGroup)
class FitnessGroupAdmin(admin.ModelAdmin):
    list_display = ('organizer', 'activity_type', 'location', 'schedule')
