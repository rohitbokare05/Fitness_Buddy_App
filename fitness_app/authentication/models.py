from django.contrib.auth.models import AbstractUser # type: ignore
from django.db import models # type: ignore

# Custom user model
class CustomUser(AbstractUser):
    ROLE_CHOICES = [
        ('buddy', 'Find a Workout Buddy'),
        ('organizer', 'Create/Manage a Fitness Group'),
    ]
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='buddy')
    profile_picture = models.ImageField(upload_to='profile_pics/', default='default.jpg')
    
class FitnessDetails(models.Model):
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE)
    fitness_goals = models.TextField(blank=True, null=True)
    workout_preferences = models.TextField(blank=True, null=True)
    availability = models.TextField(blank=True, null=True)
    
class FitnessGroup(models.Model):
    organizer = models.ForeignKey(
        CustomUser,
        on_delete=models.CASCADE,
        related_name='fitness_groups'  # Use a unique related_name
    )
    activity_type = models.CharField(max_length=100)
    location = models.CharField(max_length=255)
    schedule = models.TextField(blank=True, null=True)
    name = models.CharField(max_length=255, null=True, blank=True)  
    # name=models.CharField(max_length=50)
