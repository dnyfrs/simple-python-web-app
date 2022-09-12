# Python Flask Simple Web Application

## Table of contents

## General info
A simple web service responds HTTP GET requests and returns a JSON containing:
- Timestamp
- hostname  
  <details>
    <summary>Example response</summary>

    ```json
    {
      "Timestamp": "Sat, 10 Sep 2022 14:22:49 GMT",
      "hostname": "29ef7d9092cb"
    }
    ```
  </details>
## Technology
- Alpine 3.16
- Python 3.10.7
- Flask 2.2.2
- Docker 20.10.17
### Bootstrap
#### Unix-like (macOS/Linux)
1. Run the script using the example below:  
   `./.CICD/local/NIX/bootstrap.sh`
2. Run the command below to connect LoadBalancer services
   `minikube --log_file tunnel.log tunnel`
    1. This script might ask you for `sudo` password if enabled in the system, please enter your user password and continue
    2. This command will display an output like the example below:
       ```
       Status:
            machine: minikube
            pid: 46831
            route: 10.96.0.0/12 -> 192.168.39.81
            minikube: Running
            services: []
         errors: 
                     minikube: no errors
                     router: no errors
                     loadbalancer emulator: no errors
      ```  

3. Application responds to requests using the **simple.info** domain.  
   Use the IP address in step `2.2`, `192.168.39.81` in the example, to punch a name record in `/etc/hosts` file
   ```/etc/hosts
   192.168.39.81 simple.info
   ```

### Development
Docker is used to develop and test the application
1. Simply build the docker image  
   `docker build --tag simple-python-web-app:development -f .CICD/docker/development.Dockerfile .`
2. Run the built image  
   `docker run --name simple-web-app -p 5000:5000 simple-python-web-app:development`
3. Application will start to serve on port `5000` and can be accessed using this URL: http://127.0.0.1:5000

### Deployment

#### minikube
1. Build the docker image
   `docker build --tag simple-python-web-app:production -f .CICD/docker/production.Dockerfile .`
2. Tag the production image for docker registry
   `docker tag simple-python-web-app:production localhost:5000/simple-python-web-app`
3. Push the image
   `docker push localhost:5000/simple-python-web-app`
   <details>
   <summary>Note</summary>

      You can use the deployment script `./.CICD/deploy.k8s.sh`
   </details>
4. Visit http://simple.info address in your favourite browser
