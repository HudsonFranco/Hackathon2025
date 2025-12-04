from django.contrib.auth import get_user_model

def main():
    User = get_user_model()
    username = 'admin'
    password = 'admin'
    try:
        u = User.objects.get(username=username)
        u.set_password(password)
        u.is_staff = True
        u.is_superuser = True
        u.save()
        print('PASSWORD_UPDATED')
    except User.DoesNotExist:
        u = User.objects.create(username=username, email='admin@example.com', is_staff=True, is_superuser=True)
        u.set_password(password)
        u.save()
        print('CREATED_ADMIN')

if __name__ == '__main__':
    main()
