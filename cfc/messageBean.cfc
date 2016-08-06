component{
	public messageBean function init(){
		variables.messages = [];
		variables.errors = [];
		return this;
	}
		
	public void function addMessage(required string message){
		arrayAppend(variables.messages,{message=arguments.message});
	}
		
	public array function getMessages(){
		return variables.messages;
	}
		
	public boolean function hasMessages(){
		if(arrayLen(variables.messages)){
			return true;
		}
		else{
			return false;
		}
	}
	
	public void function clearMessages(){
		variables.messages = [];
	}
	
	public void function addError(required string message, required string field){
		arrayAppend(variables.errors,{message=arguments.message,field=arguments.field});
	}
		
	public array function getErrors(){
		return variables.errors;
	}
		
	public boolean function hasErrors(){
		if(arrayLen(variables.errors)){
			return true;
		}
		else{
			return false;
		}
	}
	
	public void function clearErrors(){
		variables.errors = [];
	}
}