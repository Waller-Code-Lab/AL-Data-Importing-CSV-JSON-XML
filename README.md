Happy Tuesday, this repository shows basic processing of singular JSON, CSV, and XML files when importing them into the Business Central Database. There is definitely better ways to process all of these files together, however this is just examples of how these files are processed.

Here in this example customer are imported through the "Upload File" action and processed as the file selected on the file type field on the page.
It is imported into the Customer Import Queue which has been created, and then under the process tab on the import queue you can process a single customer into the customer table in Business Central or at the top of the page you can process the entire import queue.
![image](https://github.com/Waller-Code-Lab/AL-Data-Importing-CSV-JSON-XML/assets/169139188/e74d9148-01d0-492f-8705-dbe8de927b5e)
Checks are done when importing into the import queue and also importing into the customer table to make sure a customer doesn't already exist with the same email. 

When importing into the import queue if a customer has the same email and already exists then the customer will be skipped and not inserted into the queue.

When importing into the Customer table in Business Central if a customer has the same email and already exists then instead of inserting the record it will modify the already existing customer with any changes.

A section has been added onto the customer card as well which captures information about the import such as whether the customer has been created or modified and at which time/by which user. This section is only visible if there has been an import for this customer.
![image](https://github.com/Waller-Code-Lab/AL-Data-Importing-CSV-JSON-XML/assets/169139188/3fc0997e-77e7-4e21-b816-a0e3279e8734)
