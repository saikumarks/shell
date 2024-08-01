pipeline {
	agent any
	stages {
		stage('build') {
		 steps {
			echo 'Building........... '
			  sh "chmod +x -R ${env.movefile}"
			sh './movefile.sh'
		}
	 }
 }
}
