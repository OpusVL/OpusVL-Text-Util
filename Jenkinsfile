node {
   stage('Build') {
      sh "/opt/perl5/bin/cpanm -M http://cpan.opusvl.com --installdeps ."
      sh "/opt/perl5/bin/prove -l t --timer --formatter=TAP::Formatter::JUnit  > ${BUILD_TAG}-junit.xml"
   }
   stage('Results') {
      junit '*junit.xml'
   }

}
