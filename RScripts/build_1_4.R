# rebuilt with 1.4

library(opentripplanner)

otp_build_graph(otp = "F:/otp-GB/otp-1.4.jar",
                dir = "F:/otp-GB",
                router = "v14",
                memory = 50000)
otp_setup(otp = "F:/otp-GB/otp-1.4.jar",
          dir = "F:/otp-GB",
          router = "v14",
          port = 8801,
          securePort = 8802)
