//Sample recurssion control code
public class CheckRecursion {
    private static boolean accountFlag = true;
    private static boolean opportunityFlag = true;
    public static boolean isFirstRunAccount(){
        if(accountFlag){
            accountFlag = false;
            return true;
        }else{
            return accountFlag;
        }
    }
    public static boolean isFirstRunOpportunity(){
        if(opportunityFlag){
            opportunityFlag = false;
            return true;
        }else{
            return opportunityFlag;
        }
    }
}