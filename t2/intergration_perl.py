'''
Created on 2012-12-13

@author: Bom
'''
import os
import string
import re
import subprocess
import sys

print len(sys.argv)
if len(sys.argv) != 5 :
    print u'args:  testpath dbname hostname port'
else:   
    testpath = sys.argv[1]
    print testpath
    dbname = sys.argv[2]
    hostname = sys.argv[3]
    port = sys.argv[4]
           
def interagrationtest():
        global testpath
        global dbname
        global hostname
        global port
        tests_list = []
#       os.chdir('t')
        abspath = os.path.abspath(testpath)
        for root, dirs, file_list in os.walk(abspath, True):
            for t in file_list:
                if re.match('^.*.pl$', t):
                    print '\n'
                    print '\n'
                    print '**********************' + t + '**********************************'
                    
                    testname = os.path.join(root, t)
#                    print "test", t
                    # os.system('perl ' + t)
                    popen = subprocess.Popen(['perl', testname, dbname, hostname, port ], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
                    output = popen.communicate()[0]
#                    print output
                    
                    lines = output.split('\n')
                    for line in lines:
                        print line
                    status = 'pass'
                    message = ''
                    for line in lines:
                        # ok 1 - 
                        m = re.search('^ok \d+ - ', line, re.I)
                        if m:
                            continue
                        
                        m = re.search('failed|error|invalid', line, re.I)
                        if m:
                            print "fail test: ", testname
                            status = 'failed'
                            message = line
                            break
                                        
                    item = [testname, status, message]
                    tests_list.append(item)
                    print testname, ": ", status
                    print '**********************' + t + '**********************************'

#        os.chdir('..')
        
        if not os.path.exists('log'):
                os.system('mkdir log')
        # change to the format that junit can be parsed. 
#        maj_ver = re.sub('\.', '_', selfddddddddddddddddddddddddd'log/test_results.xml', testsuit_name)
        testsuit_name = 'intergrationtest.CUBRID'
        generate_test_report(tests_list, 'log/test_results.xml', testsuit_name)
        
            
def generate_test_report(tests_list, log_file_name, testsuite_name):
        tests_num = len(tests_list)
        print tests_num
        failures = 0
        disabled = 0
        errors = 0

        if testsuite_name == None:
            testsuite_name = 'intergrationtest.CUBRID'

        # items:  testname status message
        for item in tests_list:
            v = item[1]
            if v == 'failed':
                failures = failures + 1
            elif v == 'disabled':
                disabled = disabled + 1
            elif v == 'error':
                errors = errors + 1
            elif v == 'pass':
                pass
                
        fp = open(log_file_name, 'w')
        fp.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        fp.write('<testsuites tests="%d" failures="%d" disabled="%d" errors="%d" time="0" name="AllTests">\n' 
                  % (tests_num, failures, disabled, errors))
        fp.write('\t<testsuite name="%s" tests="%d" failures="%d" disable="%d" errors="%d" time="0">\n' 
                  % (testsuite_name, tests_num, failures, disabled, errors))
        for item in tests_list:
            testname = item[0]
#            print testname
            status = item[1]
#            print status
            if len(item) == 2:
                message = None
            else:    
                message = item[2]
            if status == 'pass':
                fp.write('\t\t<testcase name="%s" status="pass" time="0" classname="%s">\n' % (testname, testsuite_name))
                fp.write('\t\t</testcase>\n')
            else:
                fp.write('\t\t<testcase name="%s" status="failed" time="0" classname="%s">\n' % (testname, testsuite_name))
                if message == None or message == '':
                    fp.write('\t\t\t<failure message="%s failed" type=""></failure>\n' % (testname))
                else:
                    fp.write('\t\t\t<failure message="%s" type=""></failure>\n' % (message))
                fp.write('\t\t</testcase>\n')
        fp.write('\t</testsuite>\n')
        fp.write('</testsuites>\n')
        fp.close()
    
    
if __name__ == '__main__':
       interagrationtest()  

