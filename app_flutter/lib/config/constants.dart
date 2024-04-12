const isDev = true;
// const isDev = false;

const pyExe = "C:/Python/3.12.2/python.exe";

const nameApp = "AutoCells";

const folderApp = isDev ? ".." : ".";

const updateFilePath = "$folderApp/update.exe";
const scriptsFolder = "$folderApp/scripts";
const imgToExcelPyPath = "$scriptsFolder/image_to_excel${isDev ? ".py" : ".pyc"}";

const docsFolder = nameApp;
const templatesFolder = "$nameApp/templates";

const kUriVersion = 'http://190.222.96.46:1234/version/auto-cells-version.txt';
const kUriInstaller = 'http://190.222.96.46:1234/download/auto-cells-setup.exe';

// Pages named
const kHomeScreen = '/';
const kSettingsScreen = '/settings';