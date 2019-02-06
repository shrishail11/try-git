trigger OpportunityTrigger on Opportunity (before insert,after update, after insert,before update) {
    if(CheckRecursion.isFirstRunOpportunity()){
        if(Trigger.isAfter && Trigger.isUpdate){
            Set<Id> accountIdSet = new Set<Id>();
            Map<Id,Decimal> sumByAccountMap = new Map<Id,Decimal>();
            for(Opportunity opportunity : (List<Opportunity>) Trigger.new){
                if(opportunity.Amount != null && opportunity.Amount > 0 
                   && opportunity.Amount !=  Trigger.OldMap.get(opportunity.Id).Amount){
                       accountIdSet.add(opportunity.AccountId);
                       Decimal sum = 0;
                       if(sumByAccountMap.containsKey(opportunity.AccountId)){
                           sum = sumByAccountMap.get(opportunity.AccountId);
                       }
                       sum = sum + opportunity.Amount;
                       sumByAccountMap.put(opportunity.AccountId,sum);
                   }
            }
            if(accountIdSet.size() > 0){
                List<Account> accountList = new List<Account>();
                accountList = [SELECT Id,Total_Opportunity_Amount__c FROM Account WHERE Id IN :accountIdSet];
                for(Account account : accountList){
                    if(sumByAccountMap.containsKey(account.Id) && sumByAccountMap.get(account.Id) != null){
                        account.Total_Opportunity_Amount__c = sumByAccountMap.get(account.Id);
                    }
                }
                if(accountList != null && accountList.size() > 0){
                    update accountList;
					//Shubhangi's comment
                }
            }
        }
    }
}