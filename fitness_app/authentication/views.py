from django.shortcuts import render, redirect
from django.contrib.auth import login
from .forms import CustomUserCreationForm, FitnessDetailsForm, FitnessGroupForm
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .forms import CustomUserCreationForm
from rest_framework.permissions import IsAuthenticated
from .models import CustomUser
from .serializers import UserSerializer
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.authtoken.models import Token
from rest_framework.permissions import AllowAny
from django.contrib.auth import authenticate
from .models import FitnessDetails
from .serializers import FitnessDetailsSerializer
from .models import FitnessGroup
from .serializers import FitnessGroupSerializer
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken

class LoginView(APIView):
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if not username or not password:
            return Response({'error': 'Username and password are required'}, status=status.HTTP_400_BAD_REQUEST)

        user = authenticate(username=username, password=password)

        if user is not None:
            # Create JWT token
            refresh = RefreshToken.for_user(user)
            access_token = refresh.access_token

            # Return token in response
            return Response({
                'token': str(access_token),
                'message': 'Login successful',
            })
        else:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

class FitnessGroupList(APIView):
    def get(self, request, format=None):
        fitness_groups = FitnessGroup.objects.all()  # Get all fitness groups
        serializer = FitnessGroupSerializer(fitness_groups, many=True)
        return Response(serializer.data)

class FitnessDetailsList(APIView):
    def get(self, request, format=None):
        fitness_details = FitnessDetails.objects.all()  # Get all fitness details
        serializer = FitnessDetailsSerializer(fitness_details, many=True)
        return Response(serializer.data)
    def post(self, request):
        serializer = FitnessDetailsSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
@csrf_exempt
def get_all_users(request):
    # Retrieve all users
    users = CustomUser.objects.all().values('id', 'username', 'email')  # You can adjust fields as needed
    user_list = list(users)
    return JsonResponse(user_list, safe=False)

# class LoginView(APIView):
#     permission_classes = [AllowAny]

#     def post(self, request):
#         username = request.data.get("username")
#         password = request.data.get("password")

#         user = authenticate(username=username, password=password)

#         if user is not None:
#             token, created = Token.objects.get_or_create(user=user)
#             return Response({"token": token.key})
#         return Response({"error": "Invalid credentials"}, status=400)

@csrf_exempt
def register_user(request):
    if request.method == "POST":
        form = CustomUserCreationForm(request.POST, request.FILES)
        if form.is_valid():
            user = form.save()
            return JsonResponse({"message": "User registered successfully", "user_id": user.id}, status=201)
        return JsonResponse({"errors": form.errors}, status=400)
    return JsonResponse({"error": "Invalid request method"}, status=405)

@csrf_exempt
def create_fitness_details(request):
    if request.method == "POST":
        form = FitnessDetailsForm(request.POST)
        if form.is_valid():
            details = form.save(commit=False)
            details.user = request.user  # Assuming the user is authenticated
            details.save()
            return JsonResponse({"message": "Fitness details created successfully"}, status=201)
        return JsonResponse({"errors": form.errors}, status=400)
    return JsonResponse({"error": "Invalid request method"}, status=405)

@csrf_exempt
def create_fitness_group(request):
    if request.method == "POST":
        form = FitnessGroupForm(request.POST)
        if form.is_valid():
            group = form.save(commit=False)
            group.organizer = request.user  # Assuming the user is authenticated
            group.save()
            return JsonResponse({"message": "Fitness group created successfully"}, status=201)
        return JsonResponse({"errors": form.errors}, status=400)
    return JsonResponse({"error": "Invalid request method"}, status=405)

class ProfileView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        user = request.user
        user_data = UserSerializer(user).data
        return Response(user_data)

class SuggestedFriendsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        friends = CustomUser.objects.exclude(id=user.id)
        friends_data = UserSerializer(friends, many=True).data
        return Response(friends_data)

class SignupAPI(APIView):
    def post(self, request):
        user_form = CustomUserCreationForm(request.data)
        if user_form.is_valid():
            user = user_form.save()
            return Response({"message": "User created successfully"}, status=status.HTTP_201_CREATED)
        
        # Log or return the errors
        print("User creation failed:", user_form.errors)
        return Response(user_form.errors, status=status.HTTP_400_BAD_REQUEST)
def signup_view(request):
    if request.method == 'POST':
        user_form = CustomUserCreationForm(request.POST, request.FILES)
        if user_form.is_valid():
            user = user_form.save()
            login(request, user)
            if user.role == 'buddy':
                return redirect('onboard_buddy')
            elif user.role == 'organizer':
                return redirect('onboard_organizer')
    else:
        user_form = CustomUserCreationForm()
    return render(request, 'authentication/signup.html', {'user_form': user_form})

def onboard_buddy_view(request):
    if request.method == 'POST':
        form = FitnessDetailsForm(request.POST)
        if form.is_valid():
            details = form.save(commit=False)
            details.user = request.user
            details.save()
            return redirect('home')
    else:
        form = FitnessDetailsForm()
    return render(request, 'authentication/onboard_buddy.html', {'form': form})

def onboard_organizer_view(request):
    if request.method == 'POST':
        form = FitnessGroupForm(request.POST)
        if form.is_valid():
            group = form.save(commit=False)
            group.organizer = request.user
            group.save()
            return redirect('home')
    else:
        form = FitnessGroupForm()
    return render(request, 'authentication/onboard_organizer.html', {'form': form})
