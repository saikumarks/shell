pipeline {
	agent any
	stages {
		stage('build') {
		 steps {
			echo 'Building........... '
			  sh "chmod +x movefile.sh"
			sh './movefile.sh'
		}
	 }
 }
}
