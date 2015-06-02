function [msg]  = decode(envelopes, bit_len)

means = mean(envelopes);
lib = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ,?""!?;:()1234567890';
%stdv = std(envelopes)/8;
thresholds = (max(envelopes) + min(envelopes))/2;
thresholds = [thresholds, 0, means];

collect = {};

for k = 1 : length(thresholds)
    threshold = thresholds(k);
    %threshold = 0;
    for start = 10: round(bit_len/20) : bit_len
        sample = envelopes(start : bit_len : length(envelopes));
        sample = (sample > threshold)';
        for i = 1 : 8
            msg_tmp = sample(i:end);
            padding = 8 - mod(length(msg_tmp), 8);
            msg_tmp = [msg_tmp, zeros(1,padding)];
            msg_tmp = reshape(msg_tmp, 8, [])';
            msg_tmp = num2str(msg_tmp);
            msg_tmp = char(bin2dec(msg_tmp))';
            flag_start = strfind(msg_tmp, '##');
            flag_end = strfind(msg_tmp, '%%');
            if(~isempty(flag_start) && ~isempty(flag_end))
                start_point = strfind(msg_tmp,'##');
                end_point = strfind(msg_tmp, '%%');
                msg_cutted = msg_tmp(start_point + 2: end_point - 1);
                collect{length(collect) + 1} = msg_cutted;
                break
            end
        end
    end 
end
    
    
lengths = [];
for i = 1 : length(collect)
    lengths(i) =length(collect{i});
end

length_msg = mode(lengths);

i = 1;
collect1 = {};
for j = 1: length(collect)
    if(length(collect{j}) == length_msg)
        collect1{i} = collect{j};
        i = i + 1;
    end 
end

disp('the following are collects');

for i = 1: length(collect1)
    str = collect1{i};
end

msg = char(length_msg, 1);

for j = 1: length_msg
    array = char();
    for i = 1: length(collect1)
        str = collect1{i};
        if(ismember(str(j), lib))
            array(length(array) + 1) = str(j);
        end
    end
    
    if(length(array) == 0)
        msg(j) = ' '; 
    else
        msg(j) = mode(array);
    end 
end
msg = msg';
end