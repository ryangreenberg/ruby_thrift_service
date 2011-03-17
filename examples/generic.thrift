struct GenericRequest {
  1:string message
}

struct GenericResponse {
  1:string message
}

exception GenericException {
  1: string error
}

service GenericService {
  // This service exposes a single method named "hello"
  GenericResponse hello(1:GenericRequest request) throws (1:GenericException e)
}