package swtp.clouddemo.purchase.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

	@GetMapping("/helloUser")
	public String helloUser()
	{
		
		return "helloUser";
	}
	@CrossOrigin(origins = "http://localhost:4200")
	@GetMapping("/helloAdmin")
	public String helloAdmin()
	{
		
		return "helloAdmin";
	}
	
}