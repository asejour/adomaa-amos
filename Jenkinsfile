pipeline{
    agent any
    stages{

        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/asejour/adomaa-amos']]])
            }
        }
        
        stage("deploy infrastructure"){
            steps{
                 dir('Terraform'){
                    sh "pwd"
                 }

                 sh "terraform init"
                 sh "terraform validate"
                 sh "terraform plan"
                 sh "terraform apply"
            }
        }

        stage ("navigate to Q3 root dir"){
            steps{
                dir("..\\"){
                    sh "pwd"
                }
                
            }

        }
        
        stage ("build"){
            steps {
                sh "echo 'building the project' "
                sh 'pip install flask'
     }

        }

    stage ("test"){
            steps {
                sh "echo 'testing the project' "
                sh "python test.py"

            }
        }

     stage ("run"){
            steps {
                sh "echo 'running the project' "
                sh "python  app.py"
            }
        }   
    
    }

}