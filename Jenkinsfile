pipeline{
    agent any
    stages{
        stage ("navigate to Q3 dir"){
            steps{
                dir('assignment-3/Q3'){
                    sh "pwd"
                }

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