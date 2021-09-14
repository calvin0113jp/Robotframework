<< Windows 安裝 >>

1.Dwonload and Install python

2.Update google chrome (91.0.4472.164)

2.Add python to environment variables(ex:C:\Python39\)

	My Computer > Properties > Advanced System Settings > Environment Variables >

	Just add the path as C:\Python39;C:\Python39\Scripts (or wherever you installed python)


2.把chromedriver 放在python 目錄底下(ex:c:\Python39\)


3.開始安裝套件

pip install robotframework

python -m robot --version (確認安裝成功)


pip install robotframework-selenium2library

python -c "import Selenium2Library;print(Selenium2Library.__version__)" (確認安裝成功)

4.Run script

start.bat - AT-GS950
start2.bat - Apresia

5.Test Result

跑script一段時間後,如果發現web無法login代表DUT已經crash或是重開機(syslog)
