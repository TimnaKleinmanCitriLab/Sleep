function [paths, names] = get_mice_path_and_names(FP_area)
% Helper function that returns the paths and names of the mice (acc / ofc).
% FP_area = {'ACC', 'OFC'}

if strcmp(FP_area,'ACC')
    paths={'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\ACCp\cla3',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\ACCp\cla1',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\ACCp\cla4',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\ACCp\cla6',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\ACCp\acc1',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\ACCp\acc5'};
    names={'claustrum3','claustrum1','claustrum4','claustrum6','acc1','acc5'};  % these are ACC mice specifically. make sure the order is the same order as paths entered.
elseif strcmp(FP_area,'OFC')
    paths={'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\OFCp\ofc1',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\OFCp\ofc2',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\OFCp\ofc3',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\OFCp\ofc5',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\OFCp\ofc6',...
        'C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\OFCp\ofc7'};
    names={'ofc1','ofc2','ofc3','ofc5','ofc6','ofc7'};
else
    error("No such FP area!")
end
end