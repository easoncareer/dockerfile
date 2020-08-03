#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM python:3
ADD requirements.txt /
# install libsnappy so python-snappy can install
RUN apt-get update
RUN apt-get install libsnappy-dev -qq
# install python requirements
RUN pip install --no-cache-dir -r requirements.txt
# Add Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && kubectl version --client
# Add cloud_sql_proxy
RUN curl -Lo cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 \
    && chmod +x ./cloud_sql_proxy \
    && mv ./cloud_sql_proxy /usr/local/bin/cloud_sql_proxy
# Install GCLoud SDK and add to the bash environment
RUN curl https://sdk.cloud.google.com | bash
RUN echo "source /root/google-cloud-sdk/path.bash.inc" >> ~/.bashrc
RUN echo "source /root/google-cloud-sdk/completion.bash.inc" >> ~/.bashrc
# add gcloud alpha
RUN /root/google-cloud-sdk/bin/gcloud components install alpha --quiet
EXPOSE 9042



