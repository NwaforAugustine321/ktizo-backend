"""added coupon_code data

Revision ID: 67e015e98247
Revises: 298b9bf31c27
Create Date: 2022-07-12 14:37:30.980405

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '67e015e98247'
down_revision = '298b9bf31c27'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('user', sa.Column('coupon_code', sa.String(length=255), nullable=True))
    op.add_column('user', sa.Column('coupon_status', sa.Integer(), nullable=True))
    op.add_column('user', sa.Column('coupon_created_date', sa.DateTime(), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('user', 'coupon_created_date')
    op.drop_column('user', 'coupon_status')
    op.drop_column('user', 'coupon_code')
    # ### end Alembic commands ###
