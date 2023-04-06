public class HttpException extends Exception{
		public Integer statusCode { get; set;}
		public String responseBody {get; set;}

		public HttpException(Integer statusCode, String responseBody){
			this.statusCode = statusCode;
			this.responseBody = responseBody;
		}
	}