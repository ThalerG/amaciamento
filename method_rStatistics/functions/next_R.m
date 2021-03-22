function [R,varargout] = next_R(xN,xL,xfL,vL,dL,lambda1,lambda2,lambda3)
%NEXT_R Calcula o proximo valor R
% 
% R = next_R(xN,xL,xfL,vL,dL,lambda1,lambda2,lambda3)
% [R,xfN,vN,dN] = next_R(xN,xL,xfL,vL,dL,lambda1,lambda2,lambda3)
%
% xN = x(k); xL = x(k-1); xfL = xf(k-1); vL = v(k-1) 

xfN = lambda1*xN+(1-lambda1)*xfL;
vN = lambda2*(xN-xfL)^2+(1-lambda2)*vL;
dN = lambda3*(xN-xL)^2+(1-lambda3)*dL;
R = (2-lambda1)*vN/dN;

if nargout>1
    varargout{1} = xfN;
    varargout{2} = vN;
    varargout{3} = dN;
end

end

