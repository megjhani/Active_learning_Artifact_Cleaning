function varargout = AI_GUI(varargin)
% AI_GUI MATLAB code for AI_GUI.fig
%      AI_GUI, by itself, creates a new AI_GUI or raises the existing
%      singleton*.
%
%      H = AI_GUI returns the handle to a new AI_GUI or the handle to
%      the existing singleton*.
%
%      AI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AI_GUI.M with the given input arguments.
%
%      AI_GUI('Property','Value',...) creates a new AI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AI_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AI_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AI_GUI

% Last Modified by GUIDE v2.5 08-Jan-2018 17:21:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AI_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AI_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AI_GUI is made visible.
function AI_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AI_GUI (see VARARGIN)

% Choose default command line output for AI_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AI_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
addpath(genpath('.\AL_code'));
[cumcsymbol m]= imread('CUMC.png');
axes(handles.axes5);
imshow(cumcsymbol,m);


% --- Outputs from this function are returned to the command line.
function varargout = AI_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.edit3,'string');
% disp(a);
for i = 1:str2num(a)
    textEl_desc(i) = uicontrol( 'Style', 'edit', 'Position', [30 725-(i+1)*30, 200, 20],'string',['Description for Class ',num2str(i),':'],'FontWeight','bold')
    textEl(i) = uicontrol( 'Style', 'text', 'Position', [200 725-(i+1)*30, 100, 20],'string',['Class ',num2str(i),':'],'FontWeight','bold')
    set(textEl(i),'backgroundcolor','white')
    textEl(i) = uicontrol( 'Style', 'edit', 'Position', [300 725-(i+1)*30, 100, 20])
    

end
handles.textEl = textEl
% Update handles structure
guidata(hObject, handles);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'textEl')
    h = msgbox('Enter initial labels');
    return;
end
%     dirPulseLibrary = 'C:\Murad\Columbia_Univ\2016\Code\MOCAIP_Project\MOCAIP2.0\PulseImages\';
if ~isfield(handles,'dirPulseLibrary')
    h = msgbox('Set the Pulse library');
    waitforbuttonpress();
    pushbutton3_Callback(hObject, eventdata, handles)
    handles = guidata(gcbo);
end
dirPulseLibrary = handles.dirPulseLibrary;

if ~isfield(handles,'ALModel')
    ALModel = [];
    %% set default params
    ALparam = default_params;
    ALModel.params = ALparam;
    ALModel.infomaxplot = [];
    ALModel.testAUC = [];
    ALModel.testPerformanceMetrics = [];
    ALModel.notsuretype = [];
    %% run initial AL 
    % step 1 : get the features - this can be done automatically currently
    % loading it from the directory where all the ICP pulse segments are
    % stored.
    feat_mat_dir = dir([dirPulseLibrary,'\*.mat']);
    feat_mat_table = load([dirPulseLibrary '\' feat_mat_dir.name]);
    if isfield(feat_mat_table,'aICPMo')
        feat_mat_table = struct2table(feat_mat_table.aICPMo);
        feat_mat = zscore(table2array(feat_mat_table)');
    else
%         feat_mat_table = (feat_mat_table.data);
        feat_mat_table = (feat_mat_table.training_data);
        feat_mat = zscore(feat_mat_table');
        
    end
    ALModel.features = feat_mat;
    % Step 2 : get the examples 
    nClasses = length(handles.textEl);
    idxL =  [];
    xinit = [];
    y = [];
    for i = 1: nClasses
        a = get(handles.textEl(i),'string');
        if isempty(a)
            h = msgbox('Enter initial Class labels');
            return;
        end
        idxa_i = strread(a,'%d','delimiter',',');
        idxL = [idxL;idxa_i];
        y = [y;i*ones(length(idxa_i),1)];
    end
    model = spMcLogit((feat_mat(:,idxL)),y,{(feat_mat(:,idxL))},ALparam.C,ALparam.kstd_level,ALparam.method,ALparam.stop_cond,ALparam.echo_ch);
    ALModel.idxL= idxL;
    ALModel.yidxL = y;
    ALModel.model = model;
    ALModel.info_max=[];
    ALModel = GetInformativeExample(ALModel,0);
else
    ALModel = handles.ALModel;
    ALModel = GetInformativeExample(ALModel,0); %get the updated model based on the new data
end
handles.ALModel = ALModel;
% display AUC
if length(ALModel.idxL) ~= length(ALModel.yidxL)
    exampleNumber = ALModel.idxL(end); % get the last idxL - new datapoint added
    axes(handles.axes1);
    cla;
    imshow([dirPulseLibrary,'\pulse',num2str((exampleNumber)),'.jpg']);
    a = get(handles.edit3,'string');
    for j = 1:str2num(a)
        radioclass(j) = uicontrol( 'Style', 'radio', 'Position', [200 225-(j+1)*30, 100, 20],'string',['Class ',num2str(j)],'FontWeight','bold');
        set(radioclass(j),'backgroundcolor','white')

    end
    radioclass(j+1) = uicontrol( 'Style', 'radio', 'Position', [200 225-(j+1+1)*30, 100, 20],'string',['I am not sure'],'FontWeight','bold');
    set(radioclass(j+1),'backgroundcolor','white')
    handles.radioclass = radioclass;
    % Update handles structure
end
if isfield(handles,'testdata') & isempty(handles.ALModel.testAUC) % run AUC in this section only once
    prob = spMcLogit_te(zscore(handles.testdata.feats'),handles.ALModel.model);
    [X,Y,T,AUC] = perfcurve(handles.testdata.labels,prob(:,1),1);
    handles.ALModel.testAUC = [handles.ALModel.testAUC AUC];
    [~,a] = max(prob,[],2);
    cp = classperf(handles.testdata.labels,a)    
    handles.ALModel.testPerformanceMetrics = [handles.ALModel.testPerformanceMetrics cp];
    temp = [];for i = 1:length(handles.ALModel.testPerformanceMetrics);temp = [temp handles.ALModel.testPerformanceMetrics(i).CorrectRate];end;
    axes(handles.axes4);
    cla;
    plot(handles.ALModel.testAUC,'linewidth',2.5);
    hold on;plot(temp,'linewidth',2.5);legend({'AUC','CCR'},'Location','southeast');
    
    xlabel('No. of Iterations')
    ylabel('AUC (validation set)')
    ylim([0 1])
end
guidata(hObject, handles);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dirPulseLibrary = uigetdir
disp(dirPulseLibrary);
handles.dirPulseLibrary = dirPulseLibrary;
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
classtype = 0;
addidontknowclass = 0;
for i = 1:length(handles.radioclass)
    a = get(handles.radioclass(i),'val');
    if a==1
        classtype = i;
        break;
    end
end
if classtype == 0
    h = msgbox('Select the class type');
    return;
end
if ~isfield(handles,'ALModel')
    error('ALModel is not set');
end
% check if the classtype set as 'I am not sure'
a = get(handles.edit3,'string');
if ~addidontknowclass & classtype>str2num(a) % total number of classes is same as the one that is set initially in the beginning by the user when he enters the "number of classes"
    % if classtype is i dont know and addidontknowclass is 0 then dont do
    % anything, remove the last entry from the ALModel.idxL that was added when
    % we qureied for GenInformative
    handles.ALModel.notsuretype = [handles.ALModel.notsuretype;handles.ALModel.idxL(end)];
    handles.ALModel.idxL(end)=[];
    info_max = handles.ALModel.info_max;
    ite_i = length(handles.ALModel.info_max);
    if (ite_i>3)
        temp_infomax = mean(abs(diff(info_max(end-3:end))))/mean(abs(info_max(end-3:end)));
    end
    ALParams = handles.ALModel.params
        
%     guidata(hObject, handles);
%     return;
else

        handles.ALModel.yidxL = [handles.ALModel.yidxL;classtype];
        if length(handles.ALModel.yidxL)== length(handles.ALModel.idxL) % equal number of examples
            handles.ALModel = UpdateModel(handles.ALModel);
        else
            error('Length of training features and labels are not the same');
        end

        info_max = handles.ALModel.info_max;
        ite_i = length(handles.ALModel.info_max);
        ALParams = handles.ALModel.params;

        if (ite_i>3)
            temp_infomax = mean(abs(diff(info_max(end-3:end))))/mean(abs(info_max(end-3:end)));
            handles.ALModel.infomaxplot = [handles.ALModel.infomaxplot temp_infomax];
            axes(handles.axes2);
            cla;
            plot(handles.ALModel.infomaxplot,'linewidth',2.5);
            xlabel('No. of Iterations')
            ylabel('Informaition gain')
            ylim([0 2])
        end    
            % plot the aucs for test data
        if isfield(handles,'testdata')
            prob = spMcLogit_te(zscore(handles.testdata.feats'),handles.ALModel.model);
            [X,Y,T,AUC] = perfcurve(handles.testdata.labels,prob(:,1),1);
            handles.ALModel.testAUC = [handles.ALModel.testAUC AUC];
            [~,a] = max(prob,[],2);
            cp = classperf(handles.testdata.labels,a)    ;
            disp(AUC);
            disp(confusionmat(handles.testdata.labels,a));
            handles.ALModel.testPerformanceMetrics = [handles.ALModel.testPerformanceMetrics cp];
            temp = [];for i = 1:length(handles.ALModel.testPerformanceMetrics);temp = [temp handles.ALModel.testPerformanceMetrics(i).CorrectRate];end;
            axes(handles.axes4);
            cla;
            plot(handles.ALModel.testAUC,'linewidth',2.5);
            hold on;plot(temp,'linewidth',2.5);legend({'AUC','CCR'},'Location','southeast');

            xlabel('No. of Iterations')
            ylabel('AUC (validation set)')
            ylim([0 1])
        end

end




guidata(hObject, handles);
if (ite_i>3 & temp_infomax <ALParams.sel_stop_cond) 
%     h = msgbox('I learned the model');    
    pushbutton5_Callback(hObject, eventdata, handles)
elseif (ite_i>50)
%     h = msgbox('I learned the model');    
    pushbutton2_Callback(hObject, eventdata, handles);
    pushbutton5_Callback(hObject, eventdata, handles)
else
    pushbutton2_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



prob = spMcLogit_te(handles.ALModel.features,handles.ALModel.model);
numberofexamplestoplot = 50;
nclasses = size(prob,2);
threshold = 1/nclasses;

[M,I]=max(prob,[],2);
%% plot results
axes(handles.axes3);
cla;hold on;
c = colormap(parula(nclasses+1));
for i = 1:nclasses
    data = handles.ALModel.features(:,I==i);
    if size(data,2)<numberofexamplestoplot
        numberofexamplestoplot = size(data,2);
    end
    ridx = randi(size(data,2),1,numberofexamplestoplot);
    xvals = 1:size(data,1);
    if ~isempty(data)
        plot(xvals+1.1*i*length(xvals),data(:,ridx)','color',c(i,:));
    end

end
hold off;




function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[modelfile, folder] = uigetfile();
disp(modelfile);
model_load = load(fullfile(folder,modelfile));
if isfield(model_load,'ALModel')
    handles.ALModel = model_load.ALModel;
%     handles.ALModel.infomaxplot = [];
%     handles.ALModel.testAUC = [];
%     handles.ALModel.testPerformanceMetrics = [];
%     handles.ALModel.info_max=[];
    
    guidata(hObject, handles);
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ALModel = handles.ALModel;
uisave('ALModel','model.mat');


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[testdatafile, folder] = uigetfile();
% testdatafile = uigetfile
disp(testdatafile);
testdata = load(fullfile(folder,testdatafile));

if length(fieldnames(testdata))==2 %has both features and labels
        fields = fieldnames(testdata);
        temp = getfield(testdata,cell2mat(fields(1)));
        temp2 = getfield(testdata,cell2mat(fields(2)));
        if prod(size(temp))> prod( size(temp2)) % assumption more features than total number of classes which is generally the case
            handles.testdata.feats= temp;
            handles.testdata.labels= temp2;
        else
            handles.testdata.feats= temp2;
            handles.testdata.labels= temp;
        end
end


guidata(hObject, handles);
