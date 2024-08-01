pipeline {
	agent any
	stages {
		stage('build') {
		 steps {
			echo 'Building........... '
			  sh "chmod +x -R movefile.sh"
			sh './movefile.sh'
		}
	 }
 }
}
