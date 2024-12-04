package org.it4innov.health;

import jakarta.enterprise.context.ApplicationScoped;
import lombok.extern.slf4j.Slf4j;
import org.eclipse.microprofile.config.ConfigProvider;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.HealthCheckResponseBuilder;
import org.eclipse.microprofile.health.Liveness;

import java.net.InetAddress;

@Liveness
@ApplicationScoped
@Slf4j
public class HealthCheckImpl implements HealthCheck {

    @ConfigProperty( name = "quarkus.application.version", defaultValue = "0 for test" )
    String applicationVersion;
    @ConfigProperty( name = "quarkus.application.name", defaultValue = "code-frontend" )
    String applicationName;


    @Override
    public HealthCheckResponse call() {
        final HealthCheckResponseBuilder responseBuilder =
                HealthCheckResponse.named("Application name : "+ applicationName);
        try {
            responseBuilder
                    .up()
                    .withData(
                            "nodes",
                            InetAddress
                                    .getLocalHost()
                                    .getHostName()
                                    +
                                    ":"
                                    +
                                    ConfigProvider
                                            .getConfig()
                                            .getValue( "quarkus.http.port", String.class
                                            )
                    )
                    .withData( "Application version", applicationVersion )
            ;

            log.info( "code-frontend Health check - Success" );
        } catch ( Exception e ) {
            log.error( "code-frontend Health check error - Impossible to get node hostname" );
        }

        return responseBuilder.build();
    }
}
