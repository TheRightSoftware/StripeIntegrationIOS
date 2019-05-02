
<?php
try{
require_once('./vendor/stripe/stripe-php/init.php');
    
	\Stripe\Stripe::setApiKey("sk_test_tTrzkmwUUKzaOb1DBrnwIq6m");
	echo "<pre>";

	$charge = \Stripe\Charge::create([
   	 	'amount' => $_GET['amount'],
    	'currency' => 'usd',
    	'source' => $_GET['stripeToken'],
	]);
	

                                    if(isset($charge['id']) && $charge['id'] !=''){
                                        echo "Charge created";
                                    }else{
                                        echo "Error in charge creation";
                                    }
} catch (\Exception $e) {
	print_r($e);
}
?>
