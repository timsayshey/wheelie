FROM ortussolutions/commandbox:latest

ENV CFENGINE lucee@5

COPY build/run.sh ${BUILD_DIR}/run.sh

RUN chmod +x ${BUILD_DIR}/run.sh

CMD $BUILD_DIR/run.sh
