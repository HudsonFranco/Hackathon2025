from django.core.management.base import BaseCommand, CommandError
from django.contrib.auth import get_user_model


class Command(BaseCommand):
    help = 'Create or update a superuser with specified username and password'

    def add_arguments(self, parser):
        parser.add_argument('--username', '-u', required=True, help='username to create/update')
        parser.add_argument('--password', '-p', required=True, help='password to set')
        parser.add_argument('--email', '-e', default='admin@example.com', help='email for the user')

    def handle(self, *args, **options):
        username = options['username']
        password = options['password']
        email = options['email']

        User = get_user_model()
        try:
            user = User.objects.filter(username=username).first()
            if user:
                user.set_password(password)
                user.is_staff = True
                user.is_superuser = True
                user.email = email
                user.save()
                self.stdout.write(self.style.SUCCESS('UPDATED'))
            else:
                user = User.objects.create(username=username, email=email, is_staff=True, is_superuser=True)
                user.set_password(password)
                user.save()
                self.stdout.write(self.style.SUCCESS('CREATED'))
        except Exception as exc:
            raise CommandError(str(exc))
