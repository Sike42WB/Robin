Copy and paste into a new file called secrets.env

    ROKU_DEV_TARGET=192.168.0.80
    ROKU_DEVPASSWORD=Sike1234

Save as secrets.env 

For use to deploy code to your Local Roku  


Sample Code

        import os
        from dotenv import load_dotenv  

            load_dotenv(dotenv_path='config/robin-roku-configs/secrets.env')
            DEV_TARGET = os.getenv('ROKU_DEV_TARGET')
            DEV_PASSWORD = os.getenv('ROKU_DEVPASSWORD')
