classdef Parameters
    properties
        xamp %mm
        xfreq %Hz
        xphase %degrees
        yamp %mm
        yfreq %Hz
        yphase %degrees
        zamp %mm
        zfreq %Hz
        depth %mm
        anglex %degrees
        angley %degrees
    end
    
    methods
        
        function obj = Parameters(xamp, xfreq, xphase, yamp, yfreq,...
                yphase, zamp, zfreq, depth, anglex, angley)
            %CONSTRUCTOR
            if nargin == 1
                obj.xamp = xamp(1);
                obj.xfreq = xamp(2);
                obj.xphase = xamp(3);
                obj.yamp = xamp(4);
                obj.yfreq = xamp(5);
                obj.yphase = xamp(6);
                obj.zamp = xamp(7);
                obj.zfreq = xamp(8);
                obj.depth = xamp(9);
                obj.anglex = xamp(10);
                obj.angley = xamp(11);
            else
                obj.xamp = xamp;
                obj.xfreq = xfreq;
                obj.xphase = xphase;
                obj.yamp = yamp;
                obj.yfreq = yfreq;
                obj.yphase = yphase;
                obj.zamp = zamp;
                obj.zfreq = zfreq;
                obj.depth = depth;
                obj.anglex = anglex;
                obj.angley = angley;
            end
        end
        
        function performnormalised(self,duration)
            %lowerlimits = [0; 0; 0; 0; 0; 0; 0; 0; 5; -20; -20];
            %upperlimits = [5; 6; 360; 5; 6; 360; 5; 6; 50; 20; 20];
            mxamp = 2.5*(self.xamp+1);
            mxfreq = 3*(self.xfreq+1);
            mxphase = 180*(self.xphase+1);
            myamp = 2.5*(self.yamp+1);
            myfreq = 3*(self.yfreq+1);
            myphase = 180*(self.yphase+1);
            mzamp = 2.5*(self.zamp+1);
            mzfreq = 3*(self.zfreq+1);
            mdepth = 22.5*(self.depth+1) + 5;
            manglex = 20*self.anglex;
            mangley = 20*self.angley;
            command = 'start python Call11D.py ' + string(mxamp)...
                    + ' ' + string(mxfreq) + ' ' + string(mxphase)...
                    + ' ' + string(myamp) + ' ' + string(myfreq)...
                    + ' ' + string(myphase) + ' ' + string(mzamp)...
                    + ' ' + string(mzfreq) + ' ' + string(mdepth)...
                    + ' ' + string(manglex) + ' ' + string(mangley)...
                    + ' ' + string(duration);
            system(command);
        end

        function perform(self, duration)
            command = 'start python Call11D.py ' + string(self.xamp)...
                    + ' ' + string(self.xfreq) + ' ' + string(self.xphase)...
                    + ' ' + string(self.yamp) + ' ' + string(self.yfreq)...
                    + ' ' + string(self.yphase) + ' ' + string(self.zamp)...
                    + ' ' + string(self.zfreq) + ' ' + string(self.depth)...
                    + ' ' + string(self.anglex) + ' ' + string(self.angley)...
                    + ' ' + string(duration);
            system(command);
        end
    end
end

