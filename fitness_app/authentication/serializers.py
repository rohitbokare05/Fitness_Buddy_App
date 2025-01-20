from rest_framework import serializers
from .models import CustomUser  # Import your user model
from .models import FitnessDetails
from .models import FitnessGroup

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser  # Replace with your custom user model
        fields = ['id', 'username', 'profile_picture', 'email']  # Add other fields as needed

class FitnessDetailsSerializer(serializers.ModelSerializer):
    # user = UserSerializer()
    user = serializers.SerializerMethodField()

    class Meta:
        model = FitnessDetails
        fields = ['user', 'fitness_goals', 'workout_preferences', 'availability']
    def get_user(self, obj):
        user_data = UserSerializer(obj.user).data
        user_data.pop('profile_picture', None)
        user_data.pop('id',None)
        user_data.pop('email',None)
        return user_data
class FitnessGroupSerializer(serializers.ModelSerializer):
    organizer = serializers.StringRelatedField()  # To display the username of the organizer

    # name = serializers.CharField()  # Add the 'name' field for the group name

    class Meta:
        model = FitnessGroup
        fields = ['organizer', 'activity_type', 'location', 'schedule', 'name']

    # def create(self, validated_data):
    #     # Assuming the 'name' field is being passed when the group is created
    #     group_name = validated_data.get('name')  # Get the 'name' from the incoming data
    #     group = super().create(validated_data)
    #     group.name = group_name  # Save the group name in the database
    #     group.save()  # Save the group with the 'name'
    #     return group
