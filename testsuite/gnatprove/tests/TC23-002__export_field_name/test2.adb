package body test2 with SPARK_Mode is

    procedure func1(param : out MyRecord) is
    begin
        param.reqDataLen := 1;
        param.resDataLen := 1;
    end func1;

end test2;
