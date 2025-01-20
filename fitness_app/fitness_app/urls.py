from django.contrib import admin
from django.urls import path, include
from django.http import HttpResponse
from django.conf import settings
from django.conf.urls.static import static


def home_view(request):
    return HttpResponse("Welcome to the Fitness App!")

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home_view, name='home'),  # Root URL
    path('auth/', include('authentication.urls')),  # Include your authentication app's URLs
]
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
