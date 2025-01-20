from django import forms
from django.contrib.auth.forms import UserCreationForm
from .models import CustomUser, FitnessDetails, FitnessGroup

class CustomUserCreationForm(UserCreationForm):
    ROLE_CHOICES = [
        ('buddy', 'Workout Buddy'),
        ('organizer', 'Fitness Group Organizer'),
    ]    
    email = forms.EmailField(required=True)
    role = forms.ChoiceField(choices=ROLE_CHOICES, required=True)
    class Meta:
        model = CustomUser
        fields = ['username', 'password1', 'password2', 'role', 'profile_picture']

class FitnessDetailsForm(forms.ModelForm):
    class Meta:
        model = FitnessDetails
        fields = ['fitness_goals', 'workout_preferences', 'availability']

class FitnessGroupForm(forms.ModelForm):
    class Meta:
        model = FitnessGroup
        fields = ['activity_type', 'location', 'schedule']
