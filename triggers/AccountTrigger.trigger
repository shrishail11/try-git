trigger AccountTrigger on Account (before insert,after update, after insert,before update) {
    if(CheckRecursion.isFirstRunAccount()){
        if(Trigger.isAfter && Trigger.isUpdate){
            Map<Id,String> accountNameMap = new Map<Id,String>();
            for(Account account : (List<Account>) Trigger.new){
                //if(account.Name != Trigger.OldMap.get(account.Id).Name){
                    accountNameMap.put(account.Id, account.Name);
                //}
            }
            //if(accountNameMap.size() > 0){
            system.debug('accountNameMap '+accountNameMap);
                List<Opportunity> opportunityList = new List<Opportunity>();
                opportunityList = [SELECT Id, Name, AccountId  FROM Opportunity WHERE AccountId IN : accountNameMap.keySet()];
                for(Opportunity opportunity : opportunityList){
                    if(accountNameMap.containsKey(opportunity.AccountId) && accountNameMap.get(opportunity.AccountId) != null){
                        String name = accountNameMap.get(opportunity.AccountId) +':'+ opportunity.Name ;
                        opportunity.Name = name.length() > 80 ? ( name).substring(0,79) : name ;
                        system.debug('opportunity.Name  '+opportunity.Name );
                    }
                }
                if(opportunityList != null && opportunityList.size() > 0){
                    update opportunityList;
                }
            //}
        }
    }
}